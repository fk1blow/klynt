defmodule KLTest do
  use ExUnit.Case, async: true
  doctest KL

  defmodule SimpleResource do
    use KL.Resource

    headers do
      access_token = Application.get_env(:klynt, :access_token)
      %{"Authorization" => "Bearer #{access_token}"}
    end

    get "simple_action", url: "https://api.dropboxapi.com/1/account/info"

    get "with_model", url: "https://api.dropboxapi.com/1/account/info",
                                 model: AccountInfoModel

    get "with_model_and_error", url: "api.dropboxapi.com/1/account/info",
                                 model: AccountInfoModel

    get "with_handler", url: "https://api.dropboxapi.com/1/account/info",
                    handler: ExampleHandler

    get "with_handler_and_model", url: "https://api.dropboxapi.com/1/account/info",
                    model: AccountInfoModel,
                    handler: ExampleHandler
  end

  test "generates a simple function with optional params" do
    assert SimpleResource.simple_action
  end

  test "simple resource" do
    res = SimpleResource.simple_action
    assert res == %KL.Model.Content{data: res.data}
  end

  test "resource that uses a specific model" do
    res = SimpleResource.with_model
    assert res == %AccountInfoModel{email: res.email, display_name: res.display_name}
  end

  test "resource that uses a specific model but has invalid response" do
    res = SimpleResource.with_model_and_error
    assert res == %KL.Model.Error{error: res.error}
  end

  test "resource that has handler" do
    res = SimpleResource.with_handler
    assert res == "content handled"
  end

  test "resource with handler and model" do
    res = SimpleResource.with_handler_and_model
    assert res == %{:name => res[:name], :email => res[:email]}
  end
end
