module QuestModule
  
  #=============================================================================
  # NEW PLAYER MISSIONS (1)
  #=============================================================================
  Quest1 = {
    :ID => "1",
    :Name => "Orientation",
    :QuestGiver => "Steven",
    :Stage1 => "Talk to the Nurse at The Hub.",
    :Location1 => "The Hub",
    :QuestDescription => "Before heading out on your first extraction run, make sure you know where the medical facilities are. Speak to the Nurse.",
    :RewardString => "Access to Healing Services"
  }

  #=============================================================================
  # EMPTY BOUNTY SLOTS (2-10)
  #=============================================================================
  Quest2 = {
    :ID => "2",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest3 = {
    :ID => "3",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest4 = {
    :ID => "4",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest5 = {
    :ID => "5",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest6 = {
    :ID => "6",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest7 = {
    :ID => "7",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest8 = {
    :ID => "8",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest9 = {
    :ID => "9",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  Quest10 = {
    :ID => "10",
    :Name => "Available Bounty",
    :QuestGiver => "nil",
    :Stage1 => "TBD",
    :Location1 => "nil",
    :QuestDescription => "Reserved for future Hub mission.",
    :RewardString => "nil"
  }

  #=============================================================================
  # REASSIGNED MISSIONS (11+)
  #=============================================================================
  Quest11 = {
    :ID => "11",
    :Name => "Bounty: Slayer",
    :QuestGiver => "Bounty Board",
    :Stage1 => "Defeat 5 VIP/Boss Trainers in runs.",
    :Location1 => "The Underground",
    :QuestDescription => "The Hub needs you to clear out high-value targets. Take down 5 VIP/Boss trainers during your runs.",
    :RewardString => "5 Hollowed Souls"
  }

  Quest12 = {
    :ID => "12",
    :Name => "Bounty: Gatherer",
    :QuestGiver => "Bounty Board",
    :Stage1 => "Mine 10 Hollowed Souls.",
    :Location1 => "The Underground",
    :QuestDescription => "We need raw materials. Use the mining walls during your runs to gather 10 Hollowed Souls.",
    :RewardString => "1 Fortune Coin Artifact"
  }

  Quest13 = {
    :ID => "13",
    :Name => "Bounty: Survivor",
    :QuestGiver => "Bounty Board",
    :Stage1 => "Reach Floor 20 in a single run.",
    :Location1 => "The Underground",
    :QuestDescription => "Prove your endurance. Make it to Floor 20 in a single continuous extraction run.",
    :RewardString => "1 Vitality Root Artifact"
  }

  Quest14 = {
    :ID => "14",
    :Name => "Apex Predator I",
    :QuestGiver => "Bounty Board",
    :Stage1 => "Defeat 15 VIP/Boss Trainers.",
    :Location1 => "The Underground",
    :QuestDescription => "Take down 15 VIP/Boss trainers total to unlock the next tier of this bounty.",
    :RewardString => "1 Master Ball"
  }

  Quest15 = {
    :ID => "15",
    :Name => "Apex Predator II",
    :QuestGiver => "Bounty Board",
    :Stage1 => "Defeat 30 VIP/Boss Trainers.",
    :Location1 => "The Underground",
    :QuestDescription => "Continue thinning the herd. Take down 30 VIP/Boss trainers total.",
    :RewardString => "3 Master Balls"
  }

  Quest16 = {
    :ID => "16",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }

  Quest17 = {
    :ID => "17",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }

  Quest18 = {
    :ID => "18",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }

  Quest19 = {
    :ID => "19",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }

  Quest20 = {
    :ID => "20",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }

  Quest21 = {
    :ID => "21",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }

  Quest22 = {
    :ID => "22",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }

  Quest23 = {
    :ID => "23",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }

  Quest24 = {
    :ID => "24",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end