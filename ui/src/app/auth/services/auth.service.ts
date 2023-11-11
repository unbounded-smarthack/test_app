import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  //Method to register a user:
  private apiUrl = 'http://localhost:8000'; //replace with actual api url

  constructor(private http: HttpClient) { }

  register(user: any): Observable<any> {
    const registerUrl = `${this.apiUrl}/register`;
    return this.http.post(registerUrl, user).pipe(
      map((response: any) => {  
        return response;
      })
    )
  }

  login(username: string, password:string): Observable<any> {
    const loginUrl = `${this.apiUrl}/token-auth/`;
    const user = {username: username, password: password};
    return this.http.post(loginUrl, user).pipe(
      map((response: any) => {
        //store the token in the local storage:
        localStorage.setItem('token', response.token);
        return response;
      })
    )
  }

  
}
