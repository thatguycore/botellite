;The Botellite v1 c1 ts1
;Created by ThatGuyCore
;https://github.com/thatguycore/botellite

;even that triggers when script is loaded. sets boss variable, creates and writes line to twitch_msg.txt, opens file in notepad.exe
on 1:load:{
  if (!%tw_boss) {
    twitch_boss
  }
  if (!%tw_timer) {
    twitch_time
  }
  if (!$isfile(twitch_msg.txt)) { 
    write twitch_msg.txt Add each line you want the bot to say in this file one after another. Remove this line!
    run notepad.exe twitch_msg.txt 
  }

}

;sets variable that tells script who the boss is
alias twitch_boss { set %tw_boss $input(What is your Twitch username?, e, Twitch Username, Username) }
alias twitch_time { set %tw_timer $input(How often in seconds do you want messages to play?, e, SECONDS, 600) }

;alias used to open file used to store messages with notepad.exe
alias twmsg_open { run notepad.exe twitch_msg.txt }

;alias used to read file to send message
alias twmsg_send { 
  if (!%tw_msgn) { 
    set %tw_msgn 1
    return $read(twitch_msg.txt,%tw_msgn)
  }
  elseif (%tw_msgn < $lines(twitch_msg.txt)) {
    inc %tw_msgn 1
    return $read(twitch_msg.txt,%tw_msgn)
  } 
  elseif (%tw_msgn == $lines(twitch_msg.txt)) { 
    set %tw_msgn 1 
    return $read(twitch_msg.txt,%tw_msgn)
  }
}

;/tw_act_time activates timer
alias tw_act_time { .timertwm 0 %tw_timer msg $+($chr(35),%tw_boss) $!twmsg_send }

;/tw_stp_time disables timer
alias tw_stp_time { .timertwm off }

on 1:join:#:{
  if (($chan == $+($chr(35),%tw_boss)) && ($nick == $me)) { tw_act_time }
}

on 1:part:#:{
  if (($chan == $+($chr(35),%tw_boss)) && ($nick == $me)) { tw_stp_time }
}

on 1:text:*:#:{
  ;checks to see if message is sent in your twitch channe
  if ($chan == $+($chr(35),%tw_boss)) { 
    ;checks to see if message is sent by you
    if ($nick == %tw_boss) {
      if ($1 == !addmsg) {
        write twitch_msg.txt $2- | msg $chan Added message!
} } } }
