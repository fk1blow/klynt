defmodule KL.HttpClient do
  def get(url, params, headers) do
    url = url <> params_to_string(params)
    HTTPoison.get(url, headers, [timeout: 10000])
    |> handle_response
    |> transform_response
  end

  def post(url, params, body, headers) do
    url = "#{url}#{params_to_string(params)}"
    special_headers = %{"Content-type" => "application/x-www-form-urlencoded"}
    HTTPoison.post(url, body, Map.merge(headers, special_headers))
    |> handle_response
    |> transform_response
  end

  @doc """
    handle responses from httpoison call
  """

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}}) do
    {:ok, %{:data => parse_response(body), :meta => headers}}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 301}}) do
    {:error, %{:error => "301 Moved Permanently"}}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 302}}) do
    {:error, %{:error => "302 Found"}}
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body, headers: headers}}) do
    {:error, %{:error => parse_response(body), :meta => headers}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, %{:error => "connection refused"}}
  end

  defp params_to_string(params) do
    no_ampersand = fn str -> String.slice(str, 0, String.length(str) - 1) end
    to_url_params = fn (x, acc) -> "#{acc}#{elem x, 0}=#{elem x, 1}&" end
    Dict.to_list(params)
    |> List.foldl("?", &(to_url_params.(&1, &2)))
    |> no_ampersand.()
  end

  defp parse_response(response) do
    case Poison.decode(response, keys: :atoms) do
      {:ok, result} -> result
      {:error, reason} -> reason
    end
  end

  defp transform_response({:ok, response}) do
    %KL.Model.Response{
      content: struct(KL.Model.Content, %{:data => response.data}),
      meta: struct(KL.Model.Meta, %{:data => response.meta})
    }
  end

  defp transform_response({:error, response}) do
    %KL.Model.Response{error: struct(KL.Model.Error, response)}
  end
end
