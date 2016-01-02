defmodule KL.ResponseHandler do
  def handle(data, action, nil), do: data
  def handle(data, action, handler), do: apply(handler, :handle, [action, data])
end
