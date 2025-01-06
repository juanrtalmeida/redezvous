defmodule Redezvous.Helpers.HandlerHelpers do
  @moduledoc false
  alias Redezvous.Helpers.ChangesetHelpers
  def handle_insertion(result = {:ok, _inserted_result}, _), do: result

  def handle_insertion({:error, changeset = %Ecto.Changeset{}}, message),
    do:
      {:error,
       %{
         message: message,
         errors: changeset |> ChangesetHelpers.convert_changeset_erros_to_json()
       }}
end
