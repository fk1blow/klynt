defmodule KL.Handler do
  defmodule Action do
    def delegate(data, action, nil), do: data
    def delegate(data, action, handler), do: apply(handler, :handle, [action, data])
  end

  defmodule Model do
    alias KL.Model.Response

    def transform(%Response{content: content, error: nil, meta: meta}, model) do
      case Code.eval_quoted(model) do
        {nil, _}   -> content
        {model, _} -> struct(model, content.data)
      end
    end

    def transform(%Response{content: nil, error: error}, _model) do
      error
    end
  end
end
