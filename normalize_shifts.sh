#!/usr/bin/env node

const _ = require('underscore');
const uuid = require('node-uuid')

var input = '';

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    input += chunk;
  }
});

process.stdin.on('end', () => {
  var parsed = JSON.parse(input);
  var output = normalizeShifts(parsed.map(normalizeShift));
//  var output = parsed.map(normalizeShift);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

var normalizeShift = (shift) => {
  var toReturn = {};
  toReturn.doc = {};

  toReturn.doc.id = shift.id;

  const splitDate = shift.date.split("-");
  toReturn.dateString = shift.date;
  toReturn.date = { day: Number(splitDate[2]), month: Number(splitDate[1]), year: Number(splitDate[0]) };
  if(shift.place != "Speelplein") toReturn.doc.location = shift.place;
  toReturn.doc.kind = shift.shift_type_mnemonic;
  toReturn.doc.childrenCanBePresent = true;
  toReturn.doc.crewCanBePresent = true;

  if(shift.shift_type_mnemonic != 'EXT') toReturn.doc.startAndEnd = calcStartAndEnd(shift.shift_type_mnemonic);

  toReturn.doc.price = calcPrice(shift.shift_type_mnemonic);

  return toReturn;
};

var normalizeShifts = (shifts) => {
  var grouped = _.groupBy(shifts, x => x.dateString);

  // turn object into array of objects
  return _.map(_.keys(grouped), (key) => {
    return {
      _id: key,
      kind: 'type/day/v1',
      doc: {
        date: grouped[key][0].date,
        shifts: _.map(grouped[key], x => x.doc)
      }
    };
  });
}

var calcPrice= (mnemonic) => {
  if(mnemonic === 'VM') {
    return { euro: 1, cents: 0 };
  } else if(mnemonic === 'MID') {
    return { euro: 1, cents: 0 };
  } else if(mnemonic === 'NM') {
    return { euro: 2, cents: 0 };
  } else if(mnemonic === 'EXT') {
    return { euro: 0, cents: 0 };
  } else {
    throw new Error('Unknown mnemonic: ' + mnemonic);
  }
}

const calcStartAndEnd = (mnemonic) => {
  if(mnemonic === 'VM') {
    return { start: { hour: 7, minute: 45 }, end: { hour: 12, minute: 0 } };
  } else if(mnemonic === 'MID') {
    return { start: { hour: 12, minute: 0 }, end: { hour: 13, minute: 0 } };
  } else if(mnemonic === 'NM') {
    return { start: { hour: 13, minute: 0 }, end: { hour: 17, minute: 30 } };
  } else {
    throw new Error('Unknown mnemonic: ' + mnemonic);
  }
}

