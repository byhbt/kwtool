defmodule Kwtool.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Kwtool.Account.Schemas.User{
          email: sequence(:email, fn n -> "email-#{n}@example.com" end),
          full_name: FakerElixir.Name.name(),
          company: FakerElixir.Name.name(),
          encrypted_password: Argon2.hash_pwd_salt("123456")
        }
      end
    end
  end
end
