# Pou
Pou uses app.pou.me to do some online functions like accounts, saving, etc.
# IDs
app.pou.me uses IDs to identify things like clothing, games, and users.
Lowest user ID is 98 ("Pou")
# Requests
## Before starting
Almost all requests use the POST method, and some use GET method.
All requests use the following query strings:

| Field |              Description              | Example |
|-------|:-------------------------------------:|---------|
| _a    |                   -                   | _a=1    |
| _c    |                   -                   | _c=1    |
| _v    | Version (current: 4)                  | _v=4    |
| _r    | VersionCode of the app (current: 254) | _r=254  |

These query strings indicate the current client version

Also all requests use /ajax/ path, or else it will load www.pou.me page with broken images
You also need to add *Cookie* header or pages that require log in won't work
In [login request](#Login) you can get Set-Cookie header and you need to put that content inside Cookie header.

### Structure
The requests will be displayed like this
```
{METHOD} /ajax/{sub1}
```
Query strings:
|Field|Description|Example|
|----|-|-|
|test|Sample Text|test=yes|

Result:
```
HTTP 1.1
Hello world
Header1: Hi
Imagine this text is a raw or idk: yes

{success:yes}
```

{METHOD} indicates the request method
The path next to {METHOD} must be filled with http://app.pou.me or the request won't work. (Example: http://app.pou.me/ajax/)
And the URL needs to be filled with the subs and the query strings
(Example: http://app.pou.me/ajax/test?test=yes)

# Login
```
POST /ajax/site/login
```
Query strings:
| Field | Description                                                       | Example                            |
|-------|-------------------------------------------------------------------|------------------------------------|
| e     | User email (must be url coded)                                    | e=example%40example.com            |
| p     | User password encoded in [MD5](https://en.wikipedia.org/wiki/MD5) | p=a77b55332699835c035957df17630d28 |

Example Result:
```
HTTP/1.1 200 OK  
Server : nginx  
Date : Mon, 07 Nov 2022 17:13:19 GMT  
Content-Type : text/html; charset=UTF-8  
Transfer-Encoding : chunked  
Connection : keep-alive  
Expires : Mon, 11 Jul 1988 14:19:41 GMT  
Cache-Control : no-store, no-cache, must-revalidate  
Cache-Control : post-check=0, pre-check=0  
Pragma : no-cache  
Set-Cookie : unn_session=CookieExample;path=/;domain=.pou.me;  
Content-Encoding : gzip

{poudata...}
```
**The Set-Cookie header is important because it allows to get access to more paths that requires you to log in.**

# Get Top Likes
```
GET /ajax/site/top_likes
```
Returns JSON with an array of 20 pous with most likes.

# Search Pou by nickname
```
POST /ajax/search/visit_user_by_nickname
```
Query strings:
| Field | Description                                     | Example                            |
|-------|-------------------------------------------------|------------------------------------|
| n     | Pou Nickname                                    | e=Pou                              |

Returns a JSON which contains Pou data

# Get Game Leader
