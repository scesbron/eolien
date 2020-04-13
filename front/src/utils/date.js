import { format, parse } from 'date-fns';

export const formatDate = (date) => format(date, 'dd/MM/yyyy');

export const parseApiDate = (apiDate) => parse(apiDate, 'yyyy-MM-dd', new Date());
