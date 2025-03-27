defmodule Redezvous.PubSub do 
@moduledoc """
Documentation for PubSub.
"""
  def subscribe(topic) do 
    Phoenix.PubSub.subscribe(Redezvous.PubSub, topic)
  end

  def unsubscribe(topic) do 
    Phoenix.PubSub.unsubscribe(Redezvous.PubSub, topic)
  end

  def broadcast(topic, message) do 
    Phoenix.PubSub.broadcast(Redezvous.PubSub, topic, message)
  end
end