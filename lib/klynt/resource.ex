defmodule KL.Resource do
  alias KL.HttpClient
  alias KL.Handler

  defmacro __using__(_) do
    quote do
      import KL.Resource
    end
  end

  @doc """
  The `headers` macros is used to define the default headers included
  in all the "methods" defined by the api - each call will include
  these headers.
  It generates a private function named `headers` that will be called
  with each request/action
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

    {resource_handler, _} = Code.eval_quoted(meta[:handler])
    resource_headers = meta[:headers] || %{}
    resource_model = meta[:model]

    if meta[:segment] do
      quote do
        def unquote(:"#{resource}")(segment, params \\ %{}) do
          headers = Map.merge(unquote(Macro.escape resource_headers), headers)
          handler = unquote(resource_handler)
          action = String.to_atom(unquote(resource))
          model = unquote(resource_model)
          HttpClient.get(unquote(meta[:url]) <> segment, params, headers)
          |> Handler.Model.transform(model)
          |> Handler.Action.delegate(action, handler)
        end
      end
    else
      quote do
        def unquote(:"#{resource}")(params \\ %{}) do
          headers = Map.merge(unquote(Macro.escape resource_headers), headers)
          handler = unquote(resource_handler)
          action = String.to_atom(unquote(resource))
          model = unquote(resource_model)
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
    quote do
      defp headers, do: unquote(headers)
    end
  end
end
