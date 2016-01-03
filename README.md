klynt
=====
### DSL for defining simple API clients

_still in early development stage_

## Description
klynt has a very(incomplete) small api that can define resources
which can be fetched using http(GET, POST or other http methods).
Besides the simple fetch, a resource can be manipulated/handled by
a custom module or transformed into a model(elixir struct).

**Currently, the only working macro is `get`, which will define a function
named `resource_name/1` or, if the `segment` meta is present,
`resource_name/2`,**

## API
The api is very simple - a resource has a name(which will be transformed
into a function) and "metadata".
The metadata defines some key attributes:
  * `url` which is the endpoint of the resource
  * `model` transform the raw response into the provided struct
  * `handler` passes the response handler's(module) `handle/2` function
  * `segment` additional string segments appended to the url of the resource

## get/2
The `get/2` macro accepts a resource name and "metadata". The resource name
string becomes the name of the function which will be automatically defined
and available to the module that uses `use KL.Resource`.

#### example
without an url segment:

    get 'account_info', url: "api.dropboxapi.com/1/account/info"
    
will define a function named `account_info/1` which takes a map(default %{}).
The url of the resource is the same as in the meta[:url]...

with an url segment:

    get 'account_info', url: "api.dropboxapi.com/1/account/info"
                    segment: ["path"]

will define a `account_info/2`, which takes a string and a map. The final
url of the resource will become `api.dropbox.com/1/account/info/<segment>`