defmodule KL.Handler do
  defmodule Action do
    def delegate(data, action, {nil, _}), do: data
    def delegate(data, action, {handler, _}), do: apply(handler, :handle, [action, data])
  end

  defmodule Model do
    alias KL.Model.Response

    def transform(%Response{content: content, error: nil}, model) do
      case Code.eval_quoted(model) do
        {nil, _}   -> content
        {model, _} -> struct(model, content.data)
      end
    end
    def transform(%Response{content: nil, error: error}, _), do: error
  end
end
