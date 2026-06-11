const { randomUUID } = require('crypto');

module.exports = {
  friendlyName: 'Test User and Wallet models',

  description: 'Create a test user and wallet to check model mapping.',

  fn: async function () {
    const now = new Date();

    const userId = randomUUID();
    const walletId = randomUUID();

    const randomEmail = `test${Date.now()}@finpay.com`;

    const user = await User.create({
      id: userId,
      fullName: 'Test User',
      email: randomEmail,
      passwordHash: 'hashed_password_demo',
      role: 'USER',
      status: 'ACTIVE',
      createdAt: now,
      updatedAt: now,
    }).fetch();

    const wallet = await Wallet.create({
      id: walletId,
      user: user.id,
      balance: 0,
      currency: 'VND',
      status: 'ACTIVE',
      createdAt: now,
      updatedAt: now,
    }).fetch();

    const foundUser = await User.findOne({
      id: user.id,
    });

    const foundWallet = await Wallet.findOne({
      user: user.id,
    });

    return {
      success: true,
      message: 'User and Wallet models are working',
      data: {
        user: foundUser,
        wallet: foundWallet,
      },
    };
  },
};