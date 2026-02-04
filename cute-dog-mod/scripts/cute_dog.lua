-- Cute Dog Companion mod script
-- This script defines tameable behavior, follow logic, and simple emotes.

local CuteDog = {}

CuteDog.id = "cute_dog"
CuteDog.state = {
  tame_item = "bone",
  command_item = "whistle",
  follow_distance = 4.5,
  sit_emote = "emote_sit",
  wag_emote = "emote_tail_wag"
}

function CuteDog.onSpawn(entity)
  entity:setFriendly(true)
  entity:setTameable(true)
  entity:setInteractPrompt("Feed bone to tame")
end

function CuteDog.onInteract(entity, player, item)
  if item == CuteDog.state.tame_item and not entity:isTamed() then
    if entity:tryTame(player, 0.45) then
      entity:setOwner(player)
      entity:playEmote(CuteDog.state.wag_emote)
      entity:say("Woof! Now I'm your friend.")
    else
      entity:playEmote("emote_confused")
      entity:say("Whine...")
    end
    return true
  end

  if entity:isOwnedBy(player) and item == CuteDog.state.command_item then
    if entity:isSitting() then
      entity:stand()
      entity:playEmote(CuteDog.state.wag_emote)
      entity:say("Ready!")
    else
      entity:sit()
      entity:playEmote(CuteDog.state.sit_emote)
      entity:say("I'll stay.")
    end
    return true
  end

  return false
end

function CuteDog.onTick(entity, dt)
  if entity:isTamed() and not entity:isSitting() then
    local owner = entity:getOwner()
    if owner then
      entity:follow(owner, CuteDog.state.follow_distance)
    end
  end
end

return CuteDog
