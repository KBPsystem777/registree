-- This handler is the beginning of the "Begin" tutorial series.
Handlers.add("First-Message", Handlers.utils.hasMatchingData("Morpheus?"), Handlers.utils
    .reply("I am here. You are finally awake. Are you ready to see how far the rabbit hole goes?"))

-- This handler ends the messaging tutorial within the "Begin" tutorial series.
Handlers.add("Rabbithole", Handlers.utils.hasMatchingTag("Action", "Unlock"), Handlers.utils.reply(
    "then let us test your readiness. create a chatroom and send me an invite. we will continue to see if you are truly ready there."))

-- This handler allows morpheus to join a tutorial participant's chatroom

Handlers.add("Join-Chatroom", Handlers.utils.hasMatchingTag("Action", "Join"), function(Msg)
    Send({
        Target = Msg.From,
        Tags = {
            Action = "Register"
        }
    })
end)

-- Handle spawn event
Handlers.add("hot-trinity-spawn", function(m)
    return true
end, function(m)
    -- add hot trinity to trinity registry for specific "neo"
    -- transfer 25.000 CRED to her account
    -- load/eval trinity code.
    -- Notify "neo" about Hot Trinity
end)

-- This handler broadcasts a message on the newly joined chatroom by the participant once morpheus has been registered.

Handlers.add("First-Broadcast", Handlers.utils.hasMatchingData("registered"), function(Msg)
    -- alter message to check for hot trinity by looking for the white rabbit.
    Send({
        Target = Msg.From,
        Action = "Broadcast",
        Data = "Good. Very Good.  Now, let me introduce you to Trinity.  Here is her process ID: TLP_5xtNWzDAU_V565avSyP98X2wClrVs0QODOghagU Once you have saved her process ID as you did mine, invite her to the chatroom, as well."
    })

    -- spawn hot trinity with Neo set as the user
end)
