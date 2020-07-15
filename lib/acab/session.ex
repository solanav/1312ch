defmodule Acab.Session do
    def init do
        :ets.new(:cookie_registry, [:set, :public, :named_table])
    end

    def put(key, value) do
        :ets.insert(:cookie_registry, {key, value})
    end

    def get(key) do
        :ets.lookup_element(:cookie_registry, key, 2)
    end

    def delete(key) do
        :ets.delete(:cookie_registry, key)
    end
end