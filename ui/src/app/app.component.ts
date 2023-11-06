import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'ui';
  loginValue = 'login';

  switchLoginRegister() {
    this.loginValue = this.loginValue === 'login' ? 'register' : 'login';
  }
}
