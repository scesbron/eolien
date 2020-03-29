const defaultResponse = {
  data: {},
  status: 200,
  statusText: 'OK',
  config: {},
  headers: {},
};

export const okResponse = <P>(data: P) => ({
  ...defaultResponse,
  data,
});

export const errorResponse = (status: number, errors: string[]) => ({
  status,
  response: {
    ...defaultResponse,
    data: { errors },
    status,
  },
});
