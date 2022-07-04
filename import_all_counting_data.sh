#!/bin/bash -xe

bin/rails import_counting_all_characters:exec_all
bin/rails import_counting_bonus_votes:exec_all
bin/rails import_counting_unite_attacks:exec_all

exit 0
