defmodule KL.UndefinedResourceUrl do
  defexception message: "cannot define a resource without an url"
end

defmodule KL.InvalidResourceName do
  defexception message: "the resource name is invalid - should be at least 3 items"
end
