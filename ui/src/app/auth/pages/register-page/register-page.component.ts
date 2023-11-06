import { Component } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-register-page',
  templateUrl: './register-page.component.html',
  styleUrls: ['./register-page.component.scss']
})
export class RegisterPageComponent {
  registerForm = new FormGroup({
    username: new FormControl('', Validators.required),
    email: new FormControl('', [Validators.required, Validators.email]),
    password: new FormControl('', Validators.required),
  });

  register() {
    console.log('Registration form submitted!');
    console.log(`Name: ${this.registerForm.value.username}`);
    console.log(`Email: ${this.registerForm.value.email}`);
    console.log(`Password: ${this.registerForm.value.password}`);
  }
}
