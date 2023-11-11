import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginButtonComponent } from './components/login-button/login-button.component';
import { UserInfoComponent } from './components/user-info/user-info.component';



@NgModule({
  declarations: [
    LoginButtonComponent,
    UserInfoComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    LoginButtonComponent,
    UserInfoComponent
  ]
})
export class CoreModule { }
