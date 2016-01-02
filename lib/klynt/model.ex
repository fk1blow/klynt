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
end
