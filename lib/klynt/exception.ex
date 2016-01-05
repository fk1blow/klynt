# Don't know if it should be unde `KL.Exception.UndefinedUrl` or...
# ...or should it be named after the cycle where it has occured - compile time ?
defmodule KL.UndefinedUrl do
  defexception message: "cannot define a resource without an url"
end
