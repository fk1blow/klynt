ExUnit.start()

defmodule ExampleHandler do
  def handle(:with_handler, _response), do: "content handled"

  def handle(:with_handler_and_model, response) do
    %{:name => response.display_name, :email => response.email}
  end
end

defmodule ExampleModel do
  defstruct content: nil
end

defmodule AccountInfoModel do
  defstruct display_name: nil, email: nil
end
