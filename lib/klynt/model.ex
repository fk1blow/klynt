defmodule KL.Model do
  defmodule Content do
    defstruct data: nil
  end

  defmodule Meta do
    defstruct data: nil
  end

  defmodule Error do
    defstruct error: nil, error_description: nil
  end

  defmodule Response do
    defstruct content: nil,
                error: nil,
                 meta: nil
  end

  def transform(%KL.Model.Response{content: content, error: nil, meta: meta}, model) do
    case Code.eval_quoted(model) do
      {nil, _}   -> content
      {model, _} -> struct(model, content.data)
    end
  end

  def transform(%KL.Model.Response{content: nil, error: error}, _model) do
    error
  end
end
