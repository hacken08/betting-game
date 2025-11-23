export interface ApiResponseType<T> {
  status: boolean;
  data: T;
  message: string;
  functionname: string;
}

export interface apiRequestType {
  
}

export interface ApiErrorType {
  response: {
    data: {
      code: number,
      data: Object,
      message: string,
      status: boolean
    }
  }
} 



