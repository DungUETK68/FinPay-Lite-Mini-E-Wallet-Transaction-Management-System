const { randomUUID } = require('crypto');

module.exports = {
  tableName: 'users',

  attributes: {
    id: {
      type: 'string',
      required: true,
      columnName: 'id',
    },

    fullName: {
      type: 'string',
      required: true,
      maxLength: 100,
      columnName: 'full_name',
    },

    email: {
      type: 'string',
      required: true,
      isEmail: true,
      unique: true,
      maxLength: 150,
      columnName: 'email',
    },

    passwordHash: {
      type: 'string',
      required: true,
      protect: true,
      columnName: 'password_hash',
    },

    role: {
      type: 'string',
      isIn: ['USER', 'ADMIN'],
      defaultsTo: 'USER',
      columnName: 'role',
    },

    status: {
      type: 'string',
      isIn: ['ACTIVE', 'LOCKED', 'DELETED'],
      defaultsTo: 'ACTIVE',
      columnName: 'status',
    },

    phone: {
      type: 'string',
      allowNull: true,
      maxLength: 20,
      columnName: 'phone',
    },

    address: {
      type: 'string',
      allowNull: true,
      columnName: 'address',
    },

    createdAt: {
      type: 'ref',
      columnName: 'created_at',
    },

    updatedAt: {
      type: 'ref',
      columnName: 'updated_at',
    },

    wallet: {
      collection: 'wallet',
      via: 'user',
    },
  },

  beforeCreate: function (valuesToSet, proceed) {
    if (!valuesToSet.id) {
      valuesToSet.id = randomUUID();
    }

    return proceed();
  },

  customToJSON: function () {
    const user = { ...this };
    delete user.passwordHash;
    return user;
  },
};