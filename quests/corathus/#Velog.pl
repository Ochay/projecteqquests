$min_h;
$max_h;

sub EVENT_COMBAT
{
	if($combat_state == 0)
	{
		quest::stoptimer("enrage");
		quest::stoptimer("cleave");
		quest::modifynpcstat("min_hit", 1800);
		quest::modifynpcstat("max_hit", 2200);
	}
	else
	{
		quest::settimer("enrage_up", 30);
		quest::settimer("cleave", 12);
		$min_h = 1800;
		$max_h = 2200;
		quest::shout("Rarrrrrrggh!! Velog SMASH!");
	}
}

sub EVENT_TIMER
{
	if($timer eq "enrage_up")
	{
		$min_h = $min_h + 500;
		$max_h = $max_h + 500;
		quest::modifynpcstat("min_hit", $min_h);
		quest::modifynpcstat("max_hit", $max_h);	
		quest::emote("redoubles his efforts.");
	}
	elsif($timer eq "cleave")
	{
		quest::emote("executes a cleaving attack.");
		my @cleave_targets;
		my $tar = $npc->GetTarget();
		if($tar)
		{
			push(@cleave_targets, $tar);
			my @clientlist = $entity_list->GetClientList();
			foreach $ent (@clientlist)
			{
				if($ent->GetID() != $tar->GetID())
				{
					my $m_dist = plugin::Dist($tar, $ent);
					if($m_dist <= 20.0)
					{
						push(@cleave_targets, $ent);
					}
				}
			}
			
			my $number_targets = @cleave_targets;
			my $damage_per_target = (1500 / $number_targets);
			foreach $ent (@cleave_targets)
			{
				$ent->Damage($npc, $damage_per_target, 0xFFFF, 1);
			}
		}
	}
}