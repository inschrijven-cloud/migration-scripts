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
  var parsed = JSON.parse(input);
  var output = parsed.map(normalizeChildAttendance);
  process.stdout.write(JSON.stringify( { docs: output } ));
});

var normalizeChildAttendance = (att) => {
  var toReturn = {
    doc: {},
    kind: 'type/childAttendance/v1',
    _id: att.date + '--' + att.shift_id + '--' + att.child_id
  };

  return toReturn;
};



