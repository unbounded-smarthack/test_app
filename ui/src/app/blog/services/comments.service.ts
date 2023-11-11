import {Injectable} from "@angular/core";
import {WebSocketSubject} from "rxjs/internal/observable/dom/WebSocketSubject";
import {map, Observable, of, switchMap} from "rxjs";
import {webSocket} from "rxjs/webSocket";
class Blog {
  constructor(
    public id: number,
    public title: string,
    public content: string,
  ) {
  }
}

@Injectable({
  providedIn: 'root'
})
export class CommentsService {
  connection$: WebSocketSubject<any> | undefined;
  WS_API_URL = 'ws://127.0.0.1:8000/ws';

  connect(blog_id: number): Observable<any> {
    const wsUrl = `${this.WS_API_URL}/blog/${blog_id}/comments`;
    if (this.connection$) {
      return this.connection$;
    } else {
      this.connection$ = webSocket(wsUrl);
      return this.connection$;
    }
  }

  disconnect() {
    if (this.connection$) {
      this.connection$.complete();
      this.connection$ = undefined;
    }
  }

  sendMessage(message: any) {
    if (this.connection$) {
      this.connection$.next(message);
    } else {
      console.error('Did not send message: No connection found');
    }
  }

  get_blogs(): Observable<Blog[]> {
    return of([{
      id: 1,
      title: "Blog2",
      content: "Content2"
    }]).pipe(
      map((data) =>
        data.map((blog_data) => new Blog(
          blog_data.id,
          blog_data.title,
          blog_data.content
        ))
      )
    )
  }

}
