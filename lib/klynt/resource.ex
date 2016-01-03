defmodule KL.Resource do
  alias KL.HttpClient
  alias KL.Handler.Action
  alias KL.Handler.Model

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)

      # returns the `headers/0` expression, if defined, or an empty map
      defp _headers do
        if :erlang.function_exported(__MODULE__, :headers, 0) do
          case apply(__MODULE__, :headers, []) do
            headers when is_map headers -> headers
            _                           -> %{}
          end
        else
          %{}
        end
      end
    end
  end

  @doc """
   Defines a `headers/0` function, which returned value
   shall be used by all requests made from/for a resource.
  """
  defmacro headers(do: headers), do: compile :headers, headers
  defmacro headers(headers), do: compile :headers, headers

  @doc """
    It creates `resource_name/2` function, that will provide a structured
    representation of a resource and will make  its requests of type `GET`.
    The `meta` represents an additional description of it.
  """
  defmacro get(resource, meta), do: compile :get, {resource, meta}

  @doc """
    It creates `resource_name/2` function, that will provide a structured
    representation of a resource and will make  its requests of type `POST`.
    The `meta` represents an additional description of it.
  """
  defmacro post(resource, meta), do: compile :post, {resource, meta}

  @doc false
  defp compile(:get, {resource, meta}) do
    unless meta[:url] do
      raise "cannot define a resource without an url"
    end

    if meta[:segment] do
      quote do
        def unquote(:"#{resource}")(segment, params \\ %{}) do
          meta = unquote(meta)
          handler = Code.eval_quoted(meta[:handler])
          HttpClient.get("#{meta[:url]}#{meta[:segment]}", params, _headers())
          |> Model.transform(meta[:model])
          |> Action.delegate(:"#{unquote resource}", handler)
        end
      end
    else
      quote do
        def unquote(:"#{resource}")(params \\ %{}) do
          meta = unquote(meta)
          handler = Code.eval_quoted(meta[:handler])
          HttpClient.get(meta[:url], params, _headers())
          |> Model.transform(meta[:model])
          |> Action.delegate(:"#{unquote resource}", handler)
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
    quote do: def headers, do: unquote(headers)
  end
end
