#!/usr/bin/env node

var input = '';

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    input += chunk;
  }
});

process.stdin.on('end', () => {
  var parsed = JSON.parse(input);
  var output = parsed.map(normalizeShift);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

var normalizeShift = (shift) => {
  var toReturn = {};
  toReturn.doc = {};

  toReturn.kind = 'type/shift/v1'

  toReturn._id = shift.date + '/' + shift.shift_type_mnemonic;

  const splitDate = shift.date.split("-");
  toReturn.doc.date = { day: Number(splitDate[2]), month: Number(splitDate[1]), year: Number(splitDate[0]) };
  toReturn.doc.place = shift.place;
  toReturn.doc.shiftType = {
    mnemonic: shift.shift_type_mnemonic,
    description: shift.shift_type_description
  };

  return toReturn;
};

