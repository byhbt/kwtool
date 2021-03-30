defmodule Kwtool.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Kwtool.Accounts.Schemas.User{
          email: FakerElixir.Internet.email(),
          full_name: FakerElixir.Name.name(),
          company: FakerElixir.Name.name(),
          encrypted_password: "123456"
        }
      end
    end
  end
end
