import {Component, Inject} from "@angular/core";
import {DOCUMENT} from "@angular/common";
import {AuthService} from "@auth0/auth0-angular";

@Component({
  selector: 'app-login-button',
  template: `
    <ng-container *ngIf="auth.isAuthenticated$ | async; else loggedOut">
      <button (click)="auth.logout({ logoutParams: { returnTo: document.location.origin } })">
        Log out
      </button>
    </ng-container>

    <ng-template #loggedOut>
      <button (click)="auth.loginWithRedirect()">Log in</button>
    </ng-template>
  `,
  styles: [],
})
export class LoginButtonComponent {
  constructor(@Inject(DOCUMENT) public document: Document, public auth: AuthService) {}
}
