
module.exports.models = {
  migrate: 'safe',
  schema: true,
  attributes: {
    id: { type: 'string', required: true, columnName: 'id' },
  },
};
