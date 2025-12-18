const { onSchedule } = require("firebase-functions/v2/scheduler");

const sendPeriodNotification = require("./sendPeriodNotification");
// PERIOD 1
exports.period1 = onSchedule(
  {
    schedule: "0 12 5 1 *",
    timeZone: "Europe/Istanbul",
  },
  async () => {
    await sendPeriodNotification(1);
  }
);

// PERIOD 2
exports.period2 = onSchedule(
  {
    schedule: "0 12 5 2 *",
    timeZone: "Europe/Istanbul",
  },
  async () => await sendPeriodNotification(2)
);

// PERIOD 3
exports.period3 = onSchedule(
  {
    schedule: "0 12 25 3 *",
    timeZone: "Europe/Istanbul",
  },
  async () => await sendPeriodNotification(3)
);

// PERIOD 4
exports.period4 = onSchedule(
  {
    schedule: "0 12 5 6 *",
    timeZone: "Europe/Istanbul",
  },
  async () => await sendPeriodNotification(4)
);

// PERIOD 5
exports.period5 = onSchedule(
  {
    schedule: "0 12 10 9 *",
    timeZone: "Europe/Istanbul",
  },
  async () => await sendPeriodNotification(5)
);

// PERIOD 6
exports.period6 = onSchedule(
  {
    schedule: "11 11 11 11 *",
    timeZone: "Europe/Istanbul",
  },
  async () => await sendPeriodNotification(6)
);
