module.exports = {
  friendlyName: 'Ping database',

  description: 'Check PostgreSQL database connection.',

  fn: async function () {
    const result = await sails
      .getDatastore()
      .sendNativeQuery('SELECT NOW() AS current_time;');

    return {
      success: true,
      message: 'Database connected successfully',
      data: result.rows[0],
    };
  },
};