#!/bin/bash -xe

bin/rails runner "CountingAllCharacter.destroy_all"
bin/rails runner "CountingUniteAttack.destroy_all"
bin/rails runner "CountingBonusVote.destroy_all"

bin/rails import_counting_all_characters:exec_all
bin/rails import_counting_unite_attacks:exec_all
bin/rails import_counting_bonus_votes:exec_all

exit 0
