defmodule KL.Resource do
  import Logger
  alias KL.HttpClient
  alias KL.Handler
  # alias KL.Response

  defmacro __using__(_) do
    quote do
      import KL.Resource
      @headers %{}
    end
  end

  @doc """
  The `headers` macros is used to define the default headers included
  in all the "methods" defined by the api - each call will include
  these headers.
  If valid, it redefines the `@headers`, which already
  has a default value, of `%{}`
  """
  defmacro headers(do: headers), do: compile :headers, headers
  defmacro headers(headers), do: compile :headers, headers

  @doc """
    GET method definition
    It creates the action function, named `resource_name/2` that will
    eventually call HTTPoison.get function
  """
  defmacro get(resource, meta), do: compile :get, {resource, meta}

  @doc """
    POST method definition
    It creates the action function, named `resource_name/2` that will
    eventually call HTTPoison.post function
  """
  defmacro post(resource, meta), do: compile :post, {resource, meta}

  @doc false
  defp compile(:get, {resource, meta}) do
    unless meta[:url] do
      raise "cannot define a resource without an url"
    end

    {handler, _} = Code.eval_quoted(meta[:handler])
    headers = meta[:headers] || %{}
    model = meta[:model]

    if meta[:segment] do
      quote do
        def unquote(:"#{resource}")(segment, params \\ %{}) do
          headers = Map.merge(unquote(Macro.escape headers), @headers)
          handler = unquote(handler)
          action = String.to_atom(unquote(resource))
          model = unquote(model)
          HttpClient.get(unquote(meta[:url]) <> segment, params, headers)
          |> Handler.Model.transform(model)
          |> Handler.Action.delegate(action, handler)
        end
      end
    else
      quote do
        def unquote(:"#{resource}")(params \\ %{}) do
          headers = Map.merge(unquote(Macro.escape headers), @headers)
          handler = unquote(handler)
          action = String.to_atom(unquote(resource))
          model = unquote(model)
          HttpClient.get(unquote(meta[:url]), params, headers)
          |> Handler.Model.transform(model)
          |> Handler.Action.delegate(action, handler)
        end
      end
    end
  end

  @doc false
  defp compile(:post, {resource, meta}) do
    unless meta[:url] do
      raise "cannot define a resource without an url"
    end

    IO.puts "should define the post requests"
  end

  @doc false
  defp compile(:headers, headers) do
    {headers, _} = Code.eval_quoted(headers)
    unless is_map(headers), do: Logger.warn "the headers must be map type"
    quote do: @headers unquote(Macro.escape headers) || %{}
  end
end
