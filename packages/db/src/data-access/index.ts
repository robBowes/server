import { db } from '../connection.js';
import { Auth } from './auth.js';

const auth = new Auth(db);

export { auth };
