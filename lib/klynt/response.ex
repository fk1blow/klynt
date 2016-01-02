defmodule KL.Response do
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
