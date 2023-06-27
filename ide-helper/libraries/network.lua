---@class network
---@field public latency number @ Returns the game network latency in seconds.

---@field public send fun(url: string, args: table): table @ Sends a network request to the specified URL with optional configuration.
--[[
    Use the 'args' parameter to optionally configure the request:
    - method: HTTP method to use. Defaults to "GET", but can be any HTTP verb like "POST" or "PUT"
    - headers: Dictionary of additional HTTP headers to send with request
    - data: Dictionary or string to send as request body
    - cookies: Dictionary table of cookies to send
    - timeout: How long to wait for the connection to be made before giving up
    - allow_redirects: Whether or not to allow redirection. Defaults to true
    - body_stream_callback: A method to call with each piece of the response body.
    - header_stream_callback: A method to call with each piece of the resulting header.
    - transfer_info_callback: A method to call with transfer progress data.
    - auth_type: Authentication method to use. Defaults to "none", but can also be "basic", "digest" or "negotiate"
    - username: A username to use with authentication. 'auth_type' must also be specified.
    - password: A password to use with authentication. 'auth_type' must also be specified.
    - files: A dictionary of file names to their paths on disk to upload via stream.

    If both body_stream_callback and header_stream_callback are defined, a boolean true will be returned instead of the following object.

    The return object is a dictionary with the following members:
    - code: The HTTP status code the response gave. Will not exist if header_stream_callback is defined above.
    - body: The body of the response. Will not exist if body_stream_callback is defined above.
    - headers: A dictionary of headers and their values. Will not exist if header_stream_callback is defined above.
    - headers_raw: A raw string containing the actual headers the server sent back. Will not exist if header_stream_callback is defined above.
    - set_cookies: A dictionary of cookies given by the "Set-Cookie" header from the server. Will not exist if the server did not set any cookies.
]]
---@field public download_file fun(url: string, dest: string): boolean @ Downloads a file from the specified URL and saves it to the destination path.
---@field public easy_download fun(cb: function, uri: string, path: string): void @ Downloads a file from the specified URI and saves it to the destination path.
---@field public easy_post fun(cb: function, uri: string, postfields: string): void @ Sends a POST request to the specified URI with the provided postfields.

---@type network
_G.network = {}
