#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "hc.fcrepo.org";
    .port = "8080";
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
    # Varnish will not cache response if an Authorization header, so stash
    if (req.http.Authorization) {
        set req.http.x-auth = req.http.Authorization;
        unset req.http.Authorization;
    } else {
        return(synth(401,"Restricted"));
    }
    # unset req.http.Authorization;
}

sub vcl_hash {
    # Now that we've mutually agreed to cache, return the Authorization
    if (req.http.x-auth) {
        set req.http.Authorization = req.http.x-auth;
        unset req.http.x-auth;
    }
    hash_data(req.url);
    return(lookup);
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
    unset beresp.http.set-cookie;

    # override ttl so Varnish keeps the response around
    if (beresp.ttl > 0s) {
        /* Remove Expires from backend, it's not long enough */
        unset beresp.http.expires;
    }
    /* Set the clients TTL on this object */
    set beresp.http.cache-control = "max-age=86400";
    /* override the Varnish ttl */
    set beresp.ttl = 1d;
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
