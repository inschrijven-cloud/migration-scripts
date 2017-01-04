#!/usr/bin/env node

const _ = require('underscore');

var input = '';

process.stdin.on('readable', () => {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    input += chunk;
  }
});

process.stdin.on('end', () => {
  const parsed = JSON.parse(input);
  const output = parsed.map(normalizeChildAttendance);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

const normalizeChildAttendance = (att) => {
  var toReturn = {
    doc: {
      dayId: att.date,
      dayDate: formatDate(att.date),
      shiftId: att.shift_id,
      childId: att.child_id
    },
    kind: 'type/childattendance/v1',
    _id: att.date + '--' + att.shift_id + '--' + att.child_id
  };

  return toReturn;
};

const formatDate = (date) => {
  const splitDate = date.split("-");
  return { year: Number(splitDate[0]), month: Number(splitDate[1]), day: Number(splitDate[2]) };
}

