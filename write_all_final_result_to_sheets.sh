#!/bin/bash -xe

bin/rails runner "Sheets::WriteAndUpdate::FinalResults::AllCharactersStandAlone.new.exec"
bin/rails runner "Sheets::WriteAndUpdate::FinalResults::UniteAttacks.new.exec"
# TODO: ボーナス票

exit 0
