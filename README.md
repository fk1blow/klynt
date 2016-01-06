klynt
=====
### DSL for defining simple API clients

_still in early development stage_

## Description
klynt has a very(incomplete) small api that can define resources
which can be fetched using http(GET, POST or other http methods).
Besides the simple fetch, a resource can be manipulated/handled by
a custom module or transformed into a model(elixir struct).

## API
The api is very simple - a resource has a name(which will be transformed
into a function) and "metadata".
The metadata defines some key attributes:
  * `url` which is the endpoint of the resource
  * `model` transform the raw response into the provided struct
  * `handler` passes the response handler's(module) `handle/2` function

_See more examples inside the test module!_

### get/2
The `get/2` macro accepts a resource name and "metadata". The resource name
string becomes the name of the function which will be automatically defined
and available to the module that uses `KL.Resource`. The metadata is a 
keyword list that describes the resource.

##### example

    get 'account_info', url: "api.dropboxapi.com/1/account/info"
    
will define a function named `account_info/1` which takes a map as `params`.

### post/2
The `post/2` macro accepts a resource name and "metadata". The resource name
string becomes the name of the function which will be automatically defined
and available to the module that uses `KL.Resource`. The metadata is a 
keyword list that describes the resource.

##### example

    post "shares", url: "https://api.dropboxapi.com/1/shares/auto"
    
will define a function named `shares/2` which takes a keyword list as a `body`
and map for the `headers`.

### put/2
same as `post/2` the only difference beting the http method which is `PUT`

## installation

Add klynt to your list of dependencies in mix.exs:

    def deps do
      {:klynt, git: "https://github.com/fk1blow/klynt.git"}
    end

update dependencies:

    mix deps.get
    
## todo
  * remove dropbox api as a stub(kinda urgent)
  * add type specs in order to describe the dsl
  * define the arity and type specs of the `get` macro