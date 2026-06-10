
module.exports.models = {
  migrate: 'safe',
  attributes: {
    createdAt: { type: 'number', autoCreatedAt: true },
    updatedAt: { type: 'number', autoUpdatedAt: true },
    id: { type: 'string', columnName: 'id' },
  },
};
