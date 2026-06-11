const { randomUUID } = require('crypto');

module.exports = {
  tableName: 'wallets',

  attributes: {
    id: {
      type: 'string',
      required: true,
      columnName: 'id',
    },

    user: {
      model: 'user',
      required: true,
      unique: true,
      columnName: 'user_id',
    },

    balance: {
      type: 'number',
      defaultsTo: 0,
      columnName: 'balance',
      columnType: 'numeric(18,2)',
    },

    currency: {
      type: 'string',
      defaultsTo: 'VND',
      maxLength: 10,
      columnName: 'currency',
    },

    status: {
      type: 'string',
      isIn: ['ACTIVE', 'LOCKED'],
      defaultsTo: 'ACTIVE',
      columnName: 'status',
    },

    createdAt: {
      type: 'ref',
      columnName: 'created_at',
    },

    updatedAt: {
      type: 'ref',
      columnName: 'updated_at',
    },
  },

  beforeCreate: function (valuesToSet, proceed) {
    if (!valuesToSet.id) {
      valuesToSet.id = randomUUID();
    }

    return proceed();
  },
};