interface NativeRPCMeta {
	callbackId?: string;
	event?: string;
}

interface NativeRPCMessage {
	_meta: NativeRPCMeta;
	method: string;
	service: string;
}

export interface NativeRPCResponse extends NativeRPCMessage {
	data?: unknown;
	code: number;
	message?: string;
}

export interface NativeRPCRequest extends NativeRPCMessage {
	params?: Record<string, NativeRPCParamValue>;
}

export type NativeRPCParamValue =
	| string
	| number
	| boolean
	| null
	| NativeRPCParamValue[]
	| { [key: string]: NativeRPCParamValue };
